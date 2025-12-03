import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class PolicyService {
  constructor(private prisma: PrismaService) {}

  async findAll(userId: string) {
    return this.prisma.policy.findMany({
      where: { userId },
    });
  }

  async findOne(id: string, userId: string) {
    const policy = await this.prisma.policy.findFirst({
      where: { id, userId },
      include: { claims: true },
    });

    if (!policy) {
      throw new NotFoundException(`Policy with ID ${id} not found`);
    }

    return policy;
  }
}