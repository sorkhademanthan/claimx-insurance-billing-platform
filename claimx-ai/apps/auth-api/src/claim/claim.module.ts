import { Module } from '@nestjs/common';
import { ClaimController } from './claim.controller';
import { ClaimService } from './claim.service';
import { PrismaModule } from '../prisma/prisma.module';
import { StorageModule } from '../storage/storage.module';
@Module({
  imports: [PrismaModule, StorageModule],
  controllers: [ClaimController],
  providers: [ClaimService],
})
export class ClaimModule {}
