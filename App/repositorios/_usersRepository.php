<?php

class UsersRepository
{

    public static  function findByEmail(string $email)
    {
        try {
            $response = fetchData($_ENV["API_BASE_URL"] . "/users/getUsersByEmail.php", "post", body: [
                "u" => $_ENV["API_USER_REQUEST"],
                "p" => $_ENV["API_PASSWORD_REQUEST"],
                "action_by" => $_ENV["API_ACTION_BY"],
                "token" => $_ENV["API_TOKEN_AUTH"],
                "email" => $email
            ])->start();
        } catch (Exception $e) {
            return null;
        }

        $data = $response?->data ?? null;
        $users = $data ? $data?->users : null;
        if ($users && count($users)) {
            $user_filter_by_application = array_filter($users, fn($user) => $user->id_application == $_ENV["API_ID_APPLICATION"]);
            $user = array_shift($user_filter_by_application);
        }
        return isset($user) ? $user : null;
    }
    public static function findByID($id_user)
    {
        try {
            $response = fetchData($_ENV["API_BASE_URL"] . "/users/getUser.php", "post", body: [
                "u" => $_ENV["API_USER_REQUEST"],
                "p" => $_ENV["API_PASSWORD_REQUEST"],
                "action_by" => $_ENV["API_ACTION_BY"],
                "id_user" => $id_user,
                "token" => $_ENV["API_TOKEN_AUTH"]
            ])->start();
        } catch (Exception $e) {
            return null;
        }

        $data = $response->data ?? null;
        $user = $data ? $data?->user : null;
        return  $user;
    }

    public static function findAllUser()
    {
        try {
            $response = fetchData($_ENV["API_BASE_URL"] . "/users/getUsers.php", "post", body: [
                "u" => $_ENV["API_USER_REQUEST"],
                "p" => $_ENV["API_PASSWORD_REQUEST"],
                "action_by" => $_ENV["API_ACTION_BY"],
                "token" => $_ENV["API_TOKEN_AUTH"]
            ])->start();
        } catch (Exception $e) {
            return null;
        }

        $data = $response->data ?? null;
        $users = $data ? $data?->users : null;
        return  $users;
    }
}
