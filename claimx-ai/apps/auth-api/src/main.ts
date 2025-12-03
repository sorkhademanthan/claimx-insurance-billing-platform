import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  
  // Enable validation globally
  app.useGlobalPipes(new ValidationPipe());

  const port = process.env.PORT ? parseInt(process.env.PORT, 10) : 3333;
  await app.listen(port);
  console.log(`Auth API is running on http://localhost:${port}`);
}
bootstrap();
