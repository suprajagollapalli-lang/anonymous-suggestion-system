from django.db import models

class Suggestion(models.Model):
    department = models.CharField(max_length=100)
    suggestion = models.TextField()
    sentiment = models.CharField(max_length=20, default="Neutral")
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.department} - {self.sentiment}"