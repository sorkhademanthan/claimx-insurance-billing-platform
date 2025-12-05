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


// Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIwNTg3NWU0ZS1jMzM0LTRhOTQtYTQ0MS0wMGRjOTE4OTJjYWUiLCJlbWFpbCI6ImRlbW9AY2xhaW14LmNvbSIsInJvbGUiOiJ1c2VyIiwiaWF0IjoxNzY0OTU5MjM2LCJleHAiOjE3NjQ5NjI4MzZ9.El4U7CpvyDcox9NYc5ubqpIPU8e6w08Pmmjk8ubkKr4
// id a654b0ba-5f3e-4fb4-aa74-b3933d7f623e
