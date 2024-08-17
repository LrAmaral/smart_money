import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class DashboardService {
  constructor(private readonly prisma: PrismaService) {}

  calculateDashboard(transactions: any, goals: any) {
    return {
      balance: transactions.length > 0 ? this.getBalance(transactions) : 0,
      transactionsTotal: transactions.length || 0,
      goalsTotal: goals.length || 0,
    };
  }

  getBalance(transaction: any) {
    var balance = transaction.reduce(
      (accumulator, currentValue) => accumulator + currentValue.amount,
      0,
    );

    return balance;
  }
}
