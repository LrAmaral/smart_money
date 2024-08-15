import { Module } from '@nestjs/common';
import { PrismaModule } from 'src/prisma/prisma.module';
import { DashboardService } from './dashboard.service';
import { DashboardController } from './dashboard.controller';
import { TransactionService } from 'src/transaction/transaction.service';
import { GoalService } from 'src/goal/goal.service';

@Module({
  imports: [PrismaModule],
  controllers: [DashboardController],
  providers: [DashboardService, TransactionService, GoalService],
  exports: [DashboardService],
})
export class DashboardModule {}
