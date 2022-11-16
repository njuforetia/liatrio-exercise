FROM python:3.9
ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

WORKDIR /app

COPY requirements.txt api.py .flaskenv ./
RUN pip install -r ./requirements.txt

EXPOSE 5000
CMD ["gunicorn", "-b", ":5000", "api:app"]