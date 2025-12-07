import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { AiService } from '../ai/ai.service'; // Import AiService

@Injectable()
export class ClaimService {
  constructor(
    private prisma: PrismaService,
    private readonly aiService: AiService // Inject AiService
  ) {}

  async create(userId: string, data: any) {
    // 1. Verify Policy belongs to User
    const policy = await this.prisma.policy.findFirst({
      where: { id: data.policyId, userId: userId },
    });

    if (!policy) {
      throw new NotFoundException('Policy not found or does not belong to user');
    }

    // 2. Create Claim (Initial Save)
    const claim = await this.prisma.claim.create({
      data: {
        description: data.description,
        incidentDate: new Date(data.incidentDate),
        incidentType: data.incidentType,
        status: 'PENDING',
        policyId: data.policyId,
        userId: userId,
      },
    });

    // 3. 🧠 Trigger AI Analysis (Async)
    // We await this to ensure the response includes the score, 
    // but in a high-scale system, this could be a background job.
    const analysis = await this.aiService.analyzeClaim({
      description: claim.description,
      incidentType: claim.incidentType,
      amount: policy.coverageAmount // Using coverage as proxy for claim amount for now
    });

    // 4. Update Claim with AI Results
    return this.prisma.claim.update({
      where: { id: claim.id },
      data: {
        riskScore: analysis.riskScore,
        isFlagged: analysis.isFraud,
        aiAnalysis: analysis.reason
      }
    });
  }

  async findAll(userId: string) {
    return this.prisma.claim.findMany({
      where: { userId },
      include: { policy: true },
    });
  }

  async findOne(id: string, userId: string) {
    const claim = await this.prisma.claim.findFirst({
      where: { id, userId },
      include: { policy: true },
    });
    if (!claim) throw new NotFoundException('Claim not found');
    return claim;
  }

  async addEvidence(claimId: string, fileUrl: string, fileName: string, fileType: string) {
    return this.prisma.evidence.create({
      data: {
        url: fileUrl,
        fileName: fileName,
        fileType: fileType,
        claimId: claimId,
      },
    });
  }
}
