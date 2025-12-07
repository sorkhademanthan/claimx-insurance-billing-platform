import { Module } from '@nestjs/common';
import { ClaimController } from './claim.controller';
import { ClaimService } from './claim.service';
import { PrismaModule } from '../prisma/prisma.module';
import { AiModule } from '../ai/ai.module'; // Import AiModule
import { StorageModule } from '../storage/storage.module';

@Module({
  imports: [PrismaModule, AiModule, StorageModule], // Add to imports
  controllers: [ClaimController],
  providers: [ClaimService],
})
export class ClaimModule {}
