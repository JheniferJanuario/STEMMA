using STEMMA.Application.Cadastro.DTOs.Requests;
using STEMMA.Application.Cadastro.DTOs.Responses;
using STEMMA.Application.Cadastro.Mappers;
using STEMMA.Domain.Cadastro.Repositories;

namespace STEMMA.Application.Cadastro.UseCases.Pets;

public class UpdatePetUseCase
{
    private readonly IPetRepository _petRepository;

    public UpdatePetUseCase(IPetRepository petRepository)
    {
        _petRepository = petRepository;
    }

    public async Task<PetResponse> ExecuteAsync(Guid id, UpdatePetRequest request)
    {
        var pet = await _petRepository.ObterPorIdAsync(id);

        if (pet == null)
            throw new Exception("Pet não encontrado");

        PetMapper.UpdateEntity(pet, request);

        await _petRepository.AtualizarAsync(pet);

        return PetMapper.ToResponse(pet);
    }
}