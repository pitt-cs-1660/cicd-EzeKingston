FROM python:3.11-buster AS builder 

LABEL dock=app 

WORKDIR /app

RUN pip install --upgrade pip && pip install poetry

COPY pyproject.toml .

COPY poetry.lock .

RUN poetry config virtualenvs.create false \
&& poetry install --no-root --no-interaction --no-ansi

FROM python:3.11-buster AS app

LABEL dock=app

WORKDIR /app

COPY --from=builder /app /app 

EXPOSE 8000

ENTRYPOINT ["entrypoint.sh"]

CMD ["uvicorn cc_compose.server:app --reload --host 0.0.0.0 --port 8000"]