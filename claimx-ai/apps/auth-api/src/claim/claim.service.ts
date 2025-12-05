import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ClaimService {
  constructor(private prisma: PrismaService) {}

  async create(userId: string, data: any) {
    // 1. Verify Policy belongs to User
    const policy = await this.prisma.policy.findFirst({
      where: { id: data.policyId, userId: userId },
    });

    if (!policy) {
      throw new NotFoundException('Policy not found or does not belong to user');
    }

    // 2. Create Claim
    return this.prisma.claim.create({
      data: {
        description: data.description,
        incidentDate: new Date(data.incidentDate),
        incidentType: data.incidentType,
        status: 'PENDING',
        policyId: data.policyId,
        userId: userId,
      },
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
}
