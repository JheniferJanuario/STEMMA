using STEMMA.Application.Cadastro.Veterinarios.DTOs.Response;
using STEMMA.Application.Cadastro.Veterinarios.Mappers;
using STEMMA.Domain.Cadastro.Repositories;

namespace STEMMA.Application.Cadastro.Veterinarios.UseCases;

public class GetVeterinarioByIdUseCase
{
    private readonly IVeterinarioRepository _repository;

    public GetVeterinarioByIdUseCase(
        IVeterinarioRepository repository)
    {
        _repository = repository;
    }

    public async Task<VeterinarioResponse> ExecuteAsync(
        Guid id)
    {
        var veterinario =
            await _repository.ObterPorIdAsync(id);

        if (veterinario is null)
            throw new Exception(
                "Veterinário não encontrado.");

        return VeterinarioMapper
            .ToResponse(veterinario);
    }
}