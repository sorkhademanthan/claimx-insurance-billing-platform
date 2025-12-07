import { Module } from '@nestjs/common';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { PrismaModule } from './prisma/prisma.module';
import { PolicyModule } from './policy/policy.module';
import { ClaimModule } from './claim/claim.module';
import { AiModule } from './ai/ai.module';

@Module({
  imports: [
    AuthModule,
    UsersModule,
    PrismaModule,
    PolicyModule,
    ClaimModule,
    AiModule,
  ],
})
export class AppModule {}