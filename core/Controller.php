<?php
class Controller
{
    protected $db;

    public function __construct()
    {
        $database = new Database();
        $this->db = $database->connect();
    }

    protected function loadModel($model)
    {
        $modelFile = __DIR__ . '/../models/' . $model . '.php';

        if (file_exists($modelFile)) {
            require_once $modelFile;
            return new $model($this->db);
        }

        throw new Exception("Model not found: $model");
    }

    protected function loadView($view, $data = [])
    {
        extract($data);
        $viewFile = __DIR__ . '/../views/' . $view . '.php';

        if (file_exists($viewFile)) {
            require_once $viewFile;
        } else {
            throw new Exception("View not found: $view");
        }
    }

    protected function jsonResponse($data, $statusCode = 200)
    {
        http_response_code($statusCode);
        header('Content-Type: application/json');
        echo json_encode($data);
        exit;
    }

    protected function requireAuth()
    {
        if (!isset($_SESSION['user_id']) || !isset($_SESSION['session_token'])) {
            if ($this->isAjaxRequest()) {
                $this->jsonResponse(['success' => false, 'message' => 'Unauthorized', 'redirect' => '/login'], 401);
            } else {
                header('Location: /User-Management/login');
                exit;
            }
        }
    }

    protected function requireAdmin()
    {
        $this->requireAuth();
        if ($_SESSION['user_level'] !== 'Admin') {
            if ($this->isAjaxRequest()) {
                $this->jsonResponse(['success' => false, 'message' => 'Access denied. Admin privileges required.'], 403);
            } else {
                header('Location: /User-Management/user/dashboard');
                exit;
            }
        }
    }

    protected function isAjaxRequest()
    {
        return !empty($_SERVER['HTTP_X_REQUESTED_WITH']) &&
            strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest';
    }

    protected function getClientIP()
    {
        if (!empty($_SERVER['HTTP_CLIENT_IP'])) {
            return $_SERVER['HTTP_CLIENT_IP'];
        } elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
            return $_SERVER['HTTP_X_FORWARDED_FOR'];
        } else {
            return $_SERVER['REMOTE_ADDR'];
        }
    }

    protected function getUserAgent()
    {
        return $_SERVER['HTTP_USER_AGENT'] ?? '';
    }
}
