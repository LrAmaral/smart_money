import {
  Controller,
  Get,
  Param
} from '@nestjs/common';
import { DashboardService } from './dashboard.service';
import { TransactionService } from 'src/transaction/transaction.service';
import { GoalService } from 'src/goal/goal.service';

@Controller('dashboard')
export class DashboardController {
  constructor(private readonly dashboardService: DashboardService,
              private readonly transactionService: TransactionService, 
              private readonly goalService: GoalService) {}

  @Get(':id')
  async getDashboard(@Param('id') id: string) {
    var transactions = await this.transactionService.findByUser(id);
    var goals = await this.goalService.findByUser(id);

    console.log(transactions)
    console.log(goals)

    return this.dashboardService.calculateDashboard(transactions, goals);
  }
}
