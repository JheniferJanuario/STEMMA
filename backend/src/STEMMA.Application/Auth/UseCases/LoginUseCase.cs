using STEMMA.Application.Auth.DTOs;
using STEMMA.Domain.Cadastro.Repositories;

namespace STEMMA.Application.Auth.UseCases;

public class LoginUseCase
{
    private readonly ITutorRepository _tutorRepository;
    private readonly IVeterinarioRepository _veterinarioRepository;

    public LoginUseCase(
        ITutorRepository tutorRepository,
        IVeterinarioRepository veterinarioRepository)
    {
        _tutorRepository = tutorRepository;
        _veterinarioRepository = veterinarioRepository;
    }

    public async Task<LoginResponse> ExecuteAsync(
        LoginRequest request)
    {
        var tutor = await _tutorRepository
            .ObterPorEmailAsync(request.Email);

        if (tutor is not null && tutor.Senha == request.Senha)
        {
            return new LoginResponse
            {
                Id = tutor.Id,
                Nome = tutor.Nome,
                Email = tutor.Email,
                TipoUsuario = "Tutor"
            };
        }

        var veterinario = await _veterinarioRepository
            .ObterPorEmailAsync(request.Email);

        if (veterinario is not null && veterinario.Senha == request.Senha)
        {
            return new LoginResponse
            {
                Id = veterinario.Id,
                Nome = veterinario.Nome,
                Email = veterinario.Email,
                TipoUsuario = "Veterinario"
            };
        }

        throw new Exception("Email ou senha inválidos.");
    }
}