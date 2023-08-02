class ApiUrl {
  static const _baseURL = "http://127.0.0.1:8000/api";

  static const loginPath = "$_baseURL/user/login/POST/";
  static const userPath = "$_baseURL/user/GET/";
  static const registerPath = "$_baseURL/user/register/POST/";

  static const projectPath = "$_baseURL/project/GET/";
  static const projectByIdPath = "$_baseURL/project/GET/project_id/";
  static const createProject = "$_baseURL/project/POST/";

  static const taskUserPath = "$_baseURL/task/GET/user/";
  static const taskProjectPath = "$_baseURL/task/GET/project/";
  static const taskRetrievePath = "$_baseURL/task/GET/task_detail/";
  static const taskCreatePath = "$_baseURL/task/POST/";

  static const workspaceWithUserPath = "$_baseURL/workspace/GET/user/";

  static const sendTaskCommentPath = "$_baseURL/task/";
  static const sendProjectCommentPath = "$_baseURL/project/";
}
