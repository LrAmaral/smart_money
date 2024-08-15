import { Module } from '@nestjs/common';
import { APP_GUARD } from '@nestjs/core';
import { AppService } from './app.service';
import { AuthModule } from './auth/auth.module';
import { UserModule } from './user/user.module';
import { AppController } from './app.controller';
import { PrismaModule } from './prisma/prisma.module';
import { JwtAuthGuard } from './auth/guards/jwt-auth.guard';
import { DashboardModule } from './dashboard/dashboard.module';
import { TransactionModule } from './transaction/transaction.module';
import { GoalModule } from './goal/goal.module';

@Module({
  imports: [
    PrismaModule,
    UserModule,
    AuthModule,
    DashboardModule,
    TransactionModule,
    GoalModule,
  ],
  controllers: [AppController],
  providers: [
    AppService,
    {
      provide: APP_GUARD,
      useClass: JwtAuthGuard,
    },
  ],
})
export class AppModule {}
