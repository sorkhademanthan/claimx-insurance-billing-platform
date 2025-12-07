import { Injectable, Logger } from '@nestjs/common';
import { HttpService } from '@nestjs/axios';
import { firstValueFrom } from 'rxjs';

@Injectable()
export class AiService {
  private readonly logger = new Logger(AiService.name);
  private readonly aiServiceUrl = 'http://localhost:8000'; // Python Service URL

  constructor(private readonly httpService: HttpService) {}

  async analyzeClaim(data: { description: string; incidentType: string; amount: number }) {
    this.logger.log(`🤖 Sending claim to AI Service: ${data.description.substring(0, 30)}...`);
    
    try {
      // Send POST request to Python
      const response: any = await firstValueFrom(
        this.httpService.post(`${this.aiServiceUrl}/analyze`, data)
      );
      
      this.logger.log(`✅ AI Analysis Complete. Score: ${response.data.riskScore}`);
      return response.data;
    } catch (error: any) {
      this.logger.error('❌ Failed to communicate with AI Service', error.message);
      // Fail gracefully so the user can still submit the claim
      return { 
        riskScore: null, 
        isFraud: false, 
        reason: 'AI Service Unavailable' 
      };
    }
  }
}
