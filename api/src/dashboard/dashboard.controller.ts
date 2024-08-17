import { Controller, Get, Param } from '@nestjs/common';
import { DashboardService } from './dashboard.service';
import { TransactionService } from 'src/transaction/transaction.service';
import { GoalService } from 'src/goal/goal.service';
import { UserService } from 'src/user/user.service';

@Controller('dashboard')
export class DashboardController {
  constructor(
    private readonly dashboardService: DashboardService,
    private readonly userService: UserService,
    private readonly transactionService: TransactionService,
    private readonly goalService: GoalService,
  ) {}

  @Get(':userId')
  async getDashboard(@Param('userId') userId: string) {
    var user = await this.userService.findById(userId);
    var transactions = await this.transactionService.findByUser(userId);
    var goals = await this.goalService.findByUser(userId);

    return {
      user: user,
      dashboard: this.dashboardService.calculateDashboard(transactions, goals),
    };
  }
}
