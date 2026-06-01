using Microsoft.AspNetCore.Mvc;
using STEMMA.Application.Auth.DTOs;
using STEMMA.Application.Auth.UseCases;

namespace STEMMA.Api.Controllers.Auth;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly LoginUseCase _loginUseCase;

    public AuthController(
        LoginUseCase loginUseCase)
    {
        _loginUseCase = loginUseCase;
    }

    [HttpPost("login")]
    public async Task<IActionResult> Login(
        [FromBody] LoginRequest request)
    {
        var response =
            await _loginUseCase.ExecuteAsync(request);

        return Ok(response);
    }
}