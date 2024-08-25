import { Injectable } from '@nestjs/common';
import { Goal, Transaction } from '@prisma/client';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class DashboardService {
  constructor(private readonly prisma: PrismaService) {}

  calculateDashboard(transactions: Transaction[], goals: Goal[]) {
    return {
      balance: transactions.length > 0 ? this.getBalance(transactions) : 0,
      transactionsTotal: transactions.length || 0,
      goalsTotal: goals.length || 0,
    };
  }

  getBalance(transactions: Transaction[]) {
    const balance = transactions.reduce((accumulator, transaction) => {
      if (transaction.type === 'entrada') {
        return accumulator + transaction.amount;
      } else if (transaction.type === 'saida') {
        return accumulator - transaction.amount;
      }
      return accumulator;
    }, 0);

    return balance;
  }
}
