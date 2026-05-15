from fastapi import FastAPI
from fastapi.testclient import TestClient

app = FastAPI()


@app.get("/items")
def read_items(token: str):
    return {"token": token}


@app.get("/users/{user_id}")
def read_user(user_id: int):
    return {"user_id": user_id}


client = TestClient(app)


def test_missing_required_query_param_returns_422():
    response = client.get("/items")
    assert response.status_code == 422


def test_missing_required_query_param_error_body():
    response = client.get("/items")
    assert response.json() == {
        "detail": [
            {
                "type": "missing",
                "loc": ["query", "token"],
                "msg": "Field required",
                "input": None,
            }
        ]
    }


def test_invalid_path_param_type_returns_422():
    response = client.get("/users/not-an-int")
    assert response.status_code == 422
