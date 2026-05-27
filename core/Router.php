<?php
class Router
{
    private $routes = [];

    public function add($method, $path, $handler)
    {
        $this->routes[] = [
            'method' => strtoupper($method),
            'path' => $path,
            'handler' => $handler
        ];
    }

    public function dispatch($method, $url)
    {
        $method = strtoupper($method);
        $url = '/' . trim($url, '/');
        if ($url !== '/') {
            $url = rtrim($url, '/');
        }

        foreach ($this->routes as $route) {
            if ($route['method'] === $method && $route['path'] === $url) {
                $this->callHandler($route['handler']);
                return;
            }
        }

        // 404 Not Found
        http_response_code(404);
        echo json_encode(['success' => false, 'message' => 'Route not found']);
    }

    private function callHandler($handler)
    {
        list($controller, $method) = explode('@', $handler);

        $controllerFile = __DIR__ . '/../controllers/' . $controller . '.php';

        if (!file_exists($controllerFile)) {
            throw new Exception("Controller file not found: $controllerFile");
        }

        require_once $controllerFile;

        if (!class_exists($controller)) {
            throw new Exception("Controller class not found: $controller");
        }

        $controllerInstance = new $controller();

        if (!method_exists($controllerInstance, $method)) {
            throw new Exception("Method not found: $method in $controller");
        }

        $controllerInstance->$method();
    }
}
