import { randomUUID } from 'node:crypto';
import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';
import { CreateTransactionDto } from './dto/create-transaction.dto';
import { UpdateTransactionDto } from './dto/update-transaction.dto';

@Injectable()
export class TransactionService {
  constructor(private readonly prisma: PrismaService) {}

  async create(createTransactionDto: CreateTransactionDto) {
    return await this.prisma.transaction.create({
      data: {
        id: randomUUID(),
        ...createTransactionDto,
      },
    });
  }

  findOne(id: string) {
    return this.prisma.transaction.findUnique({
      where: { id },
    });
  }

  findByUser(user_id: string) {
    return this.prisma.transaction.findMany({
      where: { user_id: user_id },
    });
  }

  async update(id: string, updateTransactionDto: UpdateTransactionDto) {
    return await this.prisma.transaction.update({
      where: { id },
      data: { ...updateTransactionDto },
    });
  }

  async remove(id: string) {
    await this.prisma.transaction.delete({
      where: { id },
    });

    return { message: 'Transação excluída com sucesso' };
  }
}
