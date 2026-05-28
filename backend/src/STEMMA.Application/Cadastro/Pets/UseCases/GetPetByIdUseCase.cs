using STEMMA.Application.Cadastro.DTOs.Responses;
using STEMMA.Application.Cadastro.Mappers;
using STEMMA.Domain.Cadastro.Repositories;

namespace STEMMA.Application.Cadastro.UseCases.Pets;

public class GetPetByIdUseCase
{
    private readonly IPetRepository _petRepository;

    public GetPetByIdUseCase(IPetRepository petRepository)
    {
        _petRepository = petRepository;
    }

    public async Task<PetResponse> ExecuteAsync(Guid id)
    {
        var pet = await _petRepository.ObterPorIdAsync(id);

        if (pet == null)
            throw new Exception("Pet não encontrado");

        return PetMapper.ToResponse(pet);
    }
}