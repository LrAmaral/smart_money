import * as bcrypt from 'bcrypt';
import { randomUUID } from 'node:crypto';
import { Injectable } from '@nestjs/common';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class UserService {
  constructor(private readonly prisma: PrismaService) {}

  async create(createUserDto: CreateUserDto) {
    const user = {
      ...createUserDto,
      password: await bcrypt.hash(createUserDto.password, 10),
    };

    const createdUser = await this.prisma.user.create({
      data: {
        id: randomUUID(),
        name: user.name,
        email: user.email,
        password: user.password,
      },
    });

    return {
      ...createdUser,
      password: undefined,
    };
  }

  findAll() {
    return this.prisma.user.findMany();
  }

  findByEmail(email: string) {
    return this.prisma.user.findUnique({
      where: { email },
    });
  }

  async update(id: string, updateUserDto: UpdateUserDto) {
    const updatedUser = await this.prisma.user.update({
      where: { id },
      data: {
        ...updateUserDto,
        password: await bcrypt.hash(updateUserDto.password, 10),
      },
    });

    return {
      ...updatedUser,
      password: undefined,
    };
  }

  async remove(id: string) {
    await this.prisma.user.delete({
      where: { id },
    });

    return {
      message: 'User deleted successfully',
    };
  }
}
