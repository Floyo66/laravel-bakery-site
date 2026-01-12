<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class ContactController extends Controller
{
    public function show()
    {
        return view('contact');
    }

    public function submit(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:50',
            'email' => [
                'required',
                'email',
                'regex:/^[\w\.-]+@[\w\.-]+\.\w+$/', // ensures username@domain.com format
            ],
            'password' => [
                'required',
                'string',
                'min:8',                     // at least 8 characters
                'regex:/[A-Z]/',             // at least one uppercase
                'regex:/[0-9]/',             // at least one number
                'regex:/[@$!%*?&]/',         // at least one special character
            ],
            'subject' => 'required|string|max:100',
            'message' => 'required|string|min:10',
        ],
            [
                'email.required' => 'Email is required.',
                'email.email' => 'Use a valid email format (username@domain.com).',
                'email.regex' => 'Use a valid email format (username@domain.com).',

                'password.required' => 'Password is required.',
                'password.min' => 'Password must be at least 8 characters long.',
                'password.regex' => 'Password must contain at least one uppercase letter, one number, and one special character.',
            ]);

        return back()->with('success', 'Your message has been sent successfully!');
    }
}
