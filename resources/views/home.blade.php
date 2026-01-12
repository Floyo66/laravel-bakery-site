@extends('layouts.app')

@section('title', 'Home')

@section('content')

    <div class="max-w-4xl mx-auto">

        <!-- Hero Section -->
        <section class="py-16 md:py-24 text-center">
            <h1 class="text-4xl md:text-5xl lg:text-6xl font-bold text-amber-900 mb-4">
                Hi, I'm Floris
            </h1>

            <p class="text-xl md:text-2xl text-amber-800/90 font-light mb-8">
                Data Scientist &nbsp;•&nbsp; IT Specialist
            </p>

            <p class="text-lg text-amber-700 max-w-2xl mx-auto leading-relaxed mb-10">
                Welcome to my Personal Website.<br>
            </p>

            <div class="flex flex-wrap justify-center gap-5">
                <a href="{{ url('/projects') }}"
                   class="inline-flex items-center px-8 py-4 bg-amber-600 hover:bg-amber-700 text-white font-medium rounded-xl shadow-md hover:shadow-lg transform hover:-translate-y-1 transition-all duration-300">
                    <span>My Projects</span>
                    <i class="fas fa-arrow-right ml-3"></i>
                </a>

                <a href="{{ url('/contact') }}"
                   class="inline-flex items-center px-8 py-4 border-2 border-amber-700 text-amber-800 hover:bg-amber-100 font-medium rounded-xl transition-all duration-300 hover:-translate-y-1">
                    Get in Touch
                </a>
            </div>
        </section>

        <!-- Quick Intro / Highlights -->
        <section class="py-16 grid md:grid-cols-3 gap-8 text-center">
            <div class="p-8 bg-white/60 backdrop-blur-sm rounded-2xl border border-amber-100 shadow-sm hover:shadow-md transition-shadow">
                <div class="text-4xl mb-4 text-amber-600">
                    <i class="fas fa-code"></i>
                </div>
                <h3 class="text-xl font-semibold text-amber-900 mb-3">Code</h3>
                <p class="text-amber-700">....</p>
            </div>

            <div class="p-8 bg-white/60 backdrop-blur-sm rounded-2xl border border-amber-100 shadow-sm hover:shadow-md transition-shadow">
                <div class="text-4xl mb-4 text-amber-600">
                    <i class="fas fa-coffee"></i>
                </div>
                <h3 class="text-xl font-semibold text-amber-900 mb-3">Coffee Powered</h3>
                <p class="text-amber-700">......</p>
            </div>

            <div class="p-8 bg-white/60 backdrop-blur-sm rounded-2xl border border-amber-100 shadow-sm hover:shadow-md transition-shadow">
                <div class="text-4xl mb-4 text-amber-600">
                    <i class="fas fa-heart"></i>
                </div>
                <h3 class="text-xl font-semibold text-amber-900 mb-3">Data Focused Projects</h3>
                <p class="text-amber-700">My main focus is on Machine Learning and the application of Models</p>
            </div>
        </section>

        <!-- Call to action footer-ish -->
        <div class="text-center py-16">
            <p class="text-xl text-amber-800 mb-6">
                Recent Projects
            </p>

            <a href="{{ url('/projects') }}"
               class="text-amber-700 hover:text-amber-900 font-medium text-lg inline-flex items-center gap-2">
                Projects →
            </a>
        </div>

    </div>

@endsection
