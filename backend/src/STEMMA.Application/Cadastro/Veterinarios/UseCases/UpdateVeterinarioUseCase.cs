using STEMMA.Application.Cadastro.DTOs.Requests;
using STEMMA.Application.Cadastro.Veterinarios.DTOs.Response;
using STEMMA.Application.Cadastro.Veterinarios.Mappers;
using STEMMA.Domain.Cadastro.Repositories;

namespace STEMMA.Application.Cadastro.Veterinarios.UseCases;

public class UpdateVeterinarioUseCase
{
    private readonly IVeterinarioRepository _repository;

    public UpdateVeterinarioUseCase(
        IVeterinarioRepository repository)
    {
        _repository = repository;
    }

    public async Task<VeterinarioResponse> ExecuteAsync(
        Guid id,
        UpdateVeterinarioRequest request)
    {
        var veterinario =
            await _repository.ObterPorIdAsync(id);

        if (veterinario is null)
            throw new Exception("Veterinário não encontrado.");

        veterinario.AlterarNome(
            request.Nome,
            request.CRMV,
            request.Email,
            request.Especialidade);

        await _repository.AtualizarAsync(veterinario);

        return VeterinarioMapper.ToResponse(veterinario);
    }
}