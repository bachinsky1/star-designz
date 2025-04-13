<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Product;
use App\Models\Category;

class ProductSeeder extends Seeder
{
    public function run(): void
    {
        $categories = Category::all();

        foreach ($categories as $category) {
            for ($i = 1; $i <= 5; $i++) {
                Product::create([
                    'title' => "{$category->name} Товар {$i}",
                    'description' => "Описание для {$category->name} Товар {$i}",
                    'price' => rand(100, 999),
                    'category_id' => $category->id,
                ]);
            }
        }
    }
}
