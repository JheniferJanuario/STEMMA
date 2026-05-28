using STEMMA.Application.Cadastro.DTOs.Responses;
using STEMMA.Application.Cadastro.Mappers;
using STEMMA.Domain.Cadastro.Repositories;

namespace STEMMA.Application.Cadastro.UseCases.Pets;

public class ListPetsUseCase
{
    private readonly IPetRepository _petRepository;

    public ListPetsUseCase(IPetRepository petRepository)
    {
        _petRepository = petRepository;
    }

    public async Task<List<PetResponse>> ExecuteAsync()
    {
        var pets = await _petRepository.ListarAsync();

        return PetMapper.ToResponseList(pets);
    }
}