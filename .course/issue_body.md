## Description

When a request is missing a required query parameter or has an otherwise invalid input, FastAPI returns HTTP `401 Unauthorized` instead of the expected `422 Unprocessable Entity`.

This is incorrect — `401` means the client is not authenticated, whereas `422` is the appropriate code for a request that is syntactically valid but fails validation. The [FastAPI documentation](https://fastapi.tiangolo.com/tutorial/query-params/#required-parameters) and the OpenAPI specification both document `422` as the response for validation errors.

## Steps to reproduce

```python
from fastapi import FastAPI

app = FastAPI()

@app.get("/items")
def read_items(token: str):
    return {"token": token}
```

```bash
curl -i http://localhost:8000/items
# Expected: HTTP 422
# Actual:   HTTP 401
```

## Expected behavior

```
HTTP/1.1 422 Unprocessable Entity
{
  "detail": [
    {
      "type": "missing",
      "loc": ["query", "token"],
      "msg": "Field required",
      "input": null
    }
  ]
}
```

## Actual behavior

```
HTTP/1.1 401 Unauthorized
```

## Environment

- FastAPI version: 0.115.3
- Python version: 3.12
- OS: macOS 14
