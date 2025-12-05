import { IsString, IsNotEmpty, IsDateString } from 'class-validator';

export class CreateClaimDto {
  @IsNotEmpty()
  @IsString()
  policyId!: string;  // 👈 Added '!'

  @IsNotEmpty()
  @IsString()
  description!: string; // 👈 Added '!'

  @IsNotEmpty()
  @IsDateString()
  incidentDate!: string; // 👈 Added '!'

  @IsNotEmpty()
  @IsString()
  incidentType!: string; // 👈 Added '!'
}