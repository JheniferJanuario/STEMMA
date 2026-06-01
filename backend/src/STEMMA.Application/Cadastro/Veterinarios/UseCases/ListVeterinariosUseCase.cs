using STEMMA.Application.Cadastro.Veterinarios.DTOs.Response;
using STEMMA.Application.Cadastro.Veterinarios.Mappers;
using STEMMA.Domain.Cadastro.Repositories;

namespace STEMMA.Application.Cadastro.Veterinarios.UseCases;

public class ListVeterinariosUseCase
{
    private readonly IVeterinarioRepository _repository;

    public ListVeterinariosUseCase(
        IVeterinarioRepository repository)
    {
        _repository = repository;
    }

    public async Task<List<VeterinarioResponse>>
        ExecuteAsync()
    {
        var veterinarios =
            await _repository.ListarAsync();

        return VeterinarioMapper
            .ToResponseList(veterinarios);
    }
}