@extends('layouts.app')
@section('content')
    <div class="text-center p-8">
        <h1 class="text-5xl font-bold text-red-600">500</h1>
        <p class="mt-4 text-lg">Oops! Something went wrong on the server.</p>
        <a href="{{ url('/') }}" class="mt-6 inline-block bg-blue-500 text-white px-4 py-2 rounded">Go Home</a>
    </div>
@endsection
