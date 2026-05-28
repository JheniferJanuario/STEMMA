using STEMMA.Application.Cadastro.DTOs.Requests;
using STEMMA.Application.Cadastro.DTOs.Responses;
using STEMMA.Application.Cadastro.Mappers;
using STEMMA.Domain.Cadastro.Repositories;

namespace STEMMA.Application.Cadastro.UseCases.Pets;

public class CreatePetUseCase
{
    private readonly IPetRepository _petRepository;

    public CreatePetUseCase(IPetRepository petRepository)
    {
        _petRepository = petRepository;
    }

    public async Task<PetResponse> ExecuteAsync(CreatePetRequest request)
    {
        var pet = PetMapper.ToEntity(request);

        await _petRepository.AdicionarAsync(pet);

        return PetMapper.ToResponse(pet);
    }
}