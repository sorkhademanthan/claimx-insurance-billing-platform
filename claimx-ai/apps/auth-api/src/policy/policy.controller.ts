import { Controller, Get, Param, UseGuards, Req } from '@nestjs/common';
import { PolicyService } from './policy.service';
import { AuthGuard } from '@nestjs/passport';

@Controller('policies')
@UseGuards(AuthGuard('jwt'))
export class PolicyController {
  constructor(private readonly policyService: PolicyService) {}

  @Get()
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  findAll(@Req() req: any) {
    // req.user.userId comes from the JWT strategy
    return this.policyService.findAll(req.user.userId);
  }

  @Get(':id')
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  findOne(@Param('id') id: string, @Req() req: any) {
    return this.policyService.findOne(id, req.user.userId);
  }
}
