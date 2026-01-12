@extends('layouts.app')

@section('content')
    <div class="max-w-lg mx-auto p-4">
        <h1 class="text-2xl font-bold mb-4">Contact Me</h1>

        {{-- Success message --}}
        @if(session('success'))
            <div class="toast bg-green-100 text-green-800 p-3 rounded mb-4">
                {{ session('success') }}
            </div>
        @endif

        <form action="{{ route('contact.submit') }}" method="POST" id="contactForm">
            @csrf

            {{-- Name --}}
            <div class="mb-4">
                <label for="name" class="block mb-1">Name</label>
                <input type="text" name="name" id="name" value="{{ old('name') }}" class="border p-2 w-full">
            </div>

            {{-- Email --}}
            <div class="mb-4">
                <label for="email" class="block mb-1">Email</label>
                <input type="email" name="email" id="email" value="{{ old('email') }}" class="border p-2 w-full">
            </div>

            {{-- Password --}}
            <div class="mb-4">
                <label for="password" class="block mb-1">Password</label>
                <input type="password" name="password" id="password" class="border p-2 w-full">
                <ul id="password-hint" class="text-gray-600 text-sm mt-1">
                    <li id="pw-length">At least 8 characters</li>
                    <li id="pw-uppercase">At least one uppercase letter</li>
                    <li id="pw-number">At least one number</li>
                    <li id="pw-special">At least one special character (@$!%*?&)</li>
                </ul>
            </div>

            {{-- Subject --}}
            <div class="mb-4">
                <label for="subject" class="block mb-1">Subject</label>
                <input type="text" name="subject" id="subject" value="{{ old('subject') }}" class="border p-2 w-full">
            </div>

            {{-- Message --}}
            <div class="mb-4">
                <label for="message" class="block mb-1">Message</label>
                <textarea name="message" id="message" rows="5" class="border p-2 w-full">{{ old('message') }}</textarea>
            </div>

            <button type="submit" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">
                Send Message
            </button>
        </form>
    </div>

    {{-- Toast container --}}
    <div id="toast-container" class="fixed top-5 right-5 z-50 space-y-2"></div>

    <script>
        const form = document.getElementById('contactForm');
        const toastContainer = document.getElementById('toast-container');

        function showToast(message) {
            const toast = document.createElement('div');
            toast.className = "bg-red-600 text-white p-3 rounded shadow-md animate-fadein";
            toast.innerText = message;
            toastContainer.appendChild(toast);

            // Remove after 4 seconds
            setTimeout(() => {
                toast.remove();
            }, 4000);
        }

        // Validation functions
        function validateEmail(email){
            const pattern = /^[\w\.-]+@[\w\.-]+\.\w+$/;
            return pattern.test(email);
        }

        function validatePassword(password){
            return {
                length: password.length >= 8,
                uppercase: /[A-Z]/.test(password),
                number: /[0-9]/.test(password),
                special: /[@$!%*?&]/.test(password)
            };
        }

        // Live password hints
        const pwInput = document.getElementById('password');
        pwInput.addEventListener('input', () => {
            const pw = validatePassword(pwInput.value);
            document.getElementById('pw-length').style.color = pw.length ? 'green' : 'gray';
            document.getElementById('pw-uppercase').style.color = pw.uppercase ? 'green' : 'gray';
            document.getElementById('pw-number').style.color = pw.number ? 'green' : 'gray';
            document.getElementById('pw-special').style.color = pw.special ? 'green' : 'gray';
        });

        // Form submit validation
        form.addEventListener('submit', function(e){
            e.preventDefault(); // prevent immediate submit
            let valid = true;

            const name = document.getElementById('name').value.trim();
            const email = document.getElementById('email').value.trim();
            const password = pwInput.value.trim();
            const subject = document.getElementById('subject').value.trim();
            const message = document.getElementById('message').value.trim();

            // Name
            if(!name){ showToast('Name is required'); valid=false; }
            // Email
            if(!email){ showToast('Email is required'); valid=false; }
            else if(!validateEmail(email)){ showToast('Use a valid email format (username@domain.com)'); valid=false; }
            // Password
            const pw = validatePassword(password);
            if(!password){ showToast('Password is required'); valid=false; }
            else if(!pw.length || !pw.uppercase || !pw.number || !pw.special){
                showToast('Password must meet all requirements above'); valid=false;
            }
            // Subject
            if(!subject){ showToast('Subject is required'); valid=false; }
            // Message
            if(!message || message.length < 10){ showToast('Message must be at least 10 characters'); valid=false; }

            if(valid){
                form.submit(); // submit if everything passes
            }
        });
    </script>

    {{-- Toast animation --}}
    <style>
        @keyframes fadein { from {opacity:0; transform:translateY(-10px);} to {opacity:1; transform:translateY(0);} }
        .animate-fadein { animation: fadein 0.3s ease; }
    </style>
@endsection
