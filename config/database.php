<?php
class Database
{
    private $host = DB_HOST;
    private $port = DB_PORT;
    private $dbname = DB_NAME;
    private $username = DB_USER;
    private $password = DB_PASS;
    private $conn;

    public function connect()
    {
        $this->conn = null;

        try {
            $dsn = "mysql:host=" . $this->host . ";port=" . $this->port . ";dbname=" . $this->dbname . ";charset=utf8mb4";
            $this->conn = new PDO($dsn, $this->username, $this->password);
            $this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            $this->conn->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            error_log("Connection Error: " . $e->getMessage());
            throw new Exception("Database connection failed");
        }

        return $this->conn;
    }

    public function callProcedure($procedureName, $params = [])
    {
        try {
            $placeholders = str_repeat('?,', count($params));
            $placeholders = rtrim($placeholders, ',');

            $sql = "CALL $procedureName($placeholders)";
            $stmt = $this->conn->prepare($sql);
            $stmt->execute($params);

            return $stmt;
        } catch (PDOException $e) {
            error_log("Procedure Error: " . $e->getMessage());
            throw new Exception("Database procedure execution failed");
        }
    }

    public function callFunction($functionName, $params = [])
    {
        try {
            $placeholders = str_repeat('?,', count($params));
            $placeholders = rtrim($placeholders, ',');

            $sql = "SELECT $functionName($placeholders) as result";
            $stmt = $this->conn->prepare($sql);
            $stmt->execute($params);

            $result = $stmt->fetch();
            return $result['result'];
        } catch (PDOException $e) {
            error_log("Function Error: " . $e->getMessage());
            throw new Exception("Database function execution failed");
        }
    }
}
