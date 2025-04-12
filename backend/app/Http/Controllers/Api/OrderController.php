<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Product;

class OrderController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return auth()->user()->orders()->with('items.product')->get();
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $data = $request->validate([
            'items' => 'required|array',
            'items.*.product_id' => 'required|exists:products,id',
            'items.*.quantity' => 'required|integer|min:1',
        ]);

        $total = 0;

        foreach ($data['items'] as $item) {
            $product = Product::findOrFail($item['product_id']);
            $total += $product->price * $item['quantity'];
        }

        $order = auth()->user()->orders()->create([
            'total' => $total,
            'status' => 'pending',
        ]);

        foreach ($data['items'] as $item) {
            $product = Product::find($item['product_id']);
            $order->items()->create([
                'product_id' => $product->id,
                'quantity' => $item['quantity'],
                'price' => $product->price,
            ]);
        }

        return response->json(['mess' => 'Заказ создан.']);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
