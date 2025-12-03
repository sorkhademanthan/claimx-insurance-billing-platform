import { Test, TestingModule } from '@nestjs/testing';
import { PolicyService } from './policy.service';
import { PrismaService } from '../prisma/prisma.service';
import { describe, beforeEach, it, expect, jest } from '@jest/globals';


describe('PolicyService', () => {
  let service: PolicyService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        PolicyService,
        {
          provide: PrismaService,
          useValue: {
            policy: {
              findMany: jest.fn(),
              findFirst: jest.fn(),
            },
          },
        },
      ],
    }).compile();

    service = module.get<PolicyService>(PolicyService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
