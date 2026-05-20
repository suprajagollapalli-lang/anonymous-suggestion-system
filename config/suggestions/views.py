from django.shortcuts import render, redirect
from django.http import JsonResponse
from .models import Suggestion
from django.db.models import Q, Count

def form_view(request):
    return render(request, 'form.html')

def submit_view(request):
    if request.method == 'POST':
        department = request.POST.get('department')
        suggestion = request.POST.get('suggestion')

        text = suggestion.lower()

        
        if "not good" in text or "bad" in text or "issue" in text or "not" in text:
         sentiment = "Negative"

        elif "good" in text or "great" in text or "nice" in text:
         sentiment = "Positive"

        else:
         sentiment = "Neutral"

        Suggestion.objects.create(
            department=department,
            suggestion=suggestion,
            sentiment=sentiment
        )

        return redirect('/success/')

    return redirect('/')

def success_view(request):
    return render(request, 'success.html')

def health_check(request):
    return JsonResponse({"status": "ok"})


def dashboard(request):
    query = request.GET.get('q')

    if query:
        data = Suggestion.objects.filter(
            Q(suggestion__icontains=query) |
            Q(department__icontains=query)
        )
    else:
        data = Suggestion.objects.all()

    stats = Suggestion.objects.values('department') \
        .annotate(count=Count('id'))

    return render(request, 'dashboard.html', {
        'data': data,
        'stats': stats
    })
