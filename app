from flask import Flask, request, jsonify
import psycopg2

app = Flask(__name__)

def conectar():
    return psycopg2.connect(
        host="HOST",
        database="DB",
        user="Diego",
        password="@Flamengo12"
    )

@app.route("/")
def home():
    return "Sistema de Controle de Gastos está online!"

@app.route("/gastos", methods=["GET"])
def listar_gastos():
    conn = conectar()
    cur = conn.cursor()
    cur.execute("SELECT * FROM gastos")
    dados = cur.fetchall()
    conn.close()
    return jsonify(dados)

@app.route("/gastos", methods=["POST"])
def adicionar_gasto():
    data = request.json
    conn = conectar()
    cur = conn.cursor()
    cur.execute(
        "INSERT INTO gastos (descricao, valor, data) VALUES (%s, %s, %s)",
        (data["descricao"], data["valor"], data["data"])
    )
    conn.commit()
    conn.close()
    return {"msg": "Gasto adicionado"}

if __name__ == "__main__":
    app.run()
