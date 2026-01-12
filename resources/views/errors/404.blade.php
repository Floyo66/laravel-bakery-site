@extends('layouts.app')
@section('content')
    <div class="text-center p-8">
        <h1 class="text-5xl font-bold text-gray-700">404</h1>
        <p class="mt-4 text-lg">Page not found.</p>
        <a href="{{ url('/contact') }}" class="mt-6 inline-block bg-blue-500 text-white px-4 py-2 rounded">Go to Contact Page</a>
    </div>
@endsection
