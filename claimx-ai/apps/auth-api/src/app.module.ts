import { Module } from '@nestjs/common';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { PrismaModule } from './prisma/prisma.module';
import { PolicyModule } from './policy/policy.module';
import { ClaimModule } from './claim/claim.module';

@Module({
  imports: [AuthModule, UsersModule, PrismaModule, PolicyModule, ClaimModule],
})
export class AppModule {}

// claim id : d1127b4a-a9ee-4200-93b7-0046f10715fa
// policy id : 7f54e808-4761-4c0b-8999-4727142ffe5c
// eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI5NzkyMGExMS0yNDBkLTQ5MjUtYWI0Ni0xNGU3YzY3MDlhNjYiLCJlbWFpbCI6ImRlbW9AY2xhaW14LmNvbSIsInJvbGUiOiJ1c2VyIiwiaWF0IjoxNzY0OTY4Mzg4LCJleHAiOjE3NjQ5NzE5ODh9.HvTJwvgtCSBd-vdudLhdEycBbQabeZKs1njTR3aM8sU