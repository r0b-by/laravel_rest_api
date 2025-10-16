<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use App\Models\User;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        User::create([
            'name' => 'Robby Adiyasa Putra',
            'email' => 'robby@example.com',
            'password' => Hash::make('hashpassword'),
            'email_verified_at' => now(),
            'remember_token' => Str::random(10),
        ]);

        User::create([
            'name' => 'back-end-developer',
            'email' => 'backend@developer.com',
            'password' => Hash::make('hashpassword'),
            'email_verified_at' => now(),
            'remember_token' => Str::random(10),
        ]);
    }
}
