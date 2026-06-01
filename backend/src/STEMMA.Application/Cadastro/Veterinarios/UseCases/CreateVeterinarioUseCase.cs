using STEMMA.Application.Cadastro.DTOs.Requests;
using STEMMA.Application.Cadastro.Veterinarios.DTOs.Requests;
using STEMMA.Application.Cadastro.Veterinarios.Mappers;
using STEMMA.Domain.Cadastro.Repositories;

namespace STEMMA.Application.Cadastro.Veterinarios.UseCases;

public class CreateVeterinarioUseCase
    : ICreateVeterinarioUseCase
{
    private readonly IVeterinarioRepository _repository;

    public CreateVeterinarioUseCase(
        IVeterinarioRepository repository)
    {
        _repository = repository;
    }

    public async Task<Guid> ExecuteAsync(
        CreateVeterinarioRequest request)
    {
        var veterinario =
            VeterinarioMapper.ToEntity(request);

        await _repository.AdicionarAsync(
            veterinario);

        return veterinario.Id;
    }
}