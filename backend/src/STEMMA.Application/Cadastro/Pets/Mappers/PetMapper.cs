using STEMMA.Application.Cadastro.DTOs.Requests;
using STEMMA.Application.Cadastro.DTOs.Responses;
using STEMMA.Domain.Cadastro.Entities;

namespace STEMMA.Application.Cadastro.Mappers;

public static class PetMapper
{
    // Request → Entity (CREATE)
    public static Pet ToEntity(CreatePetRequest request)
    {
        return new Pet(
            request.Nome,
            request.Raca,
            request.Idade,
            request.Peso,
            request.TutorId
        );
    }

    // Entity → Response
    public static PetResponse ToResponse(Pet pet)
    {
        return new PetResponse
        {
            Id = pet.Id,
            Nome = pet.Nome,
            Raca = pet.Raca,
            Idade = pet.Idade,
            Peso = pet.Peso,
            Status = pet.Status,
            TutorId = pet.TutorId
        };
    }

    // List<Entity> → List<Response>
    public static List<PetResponse> ToResponseList(IEnumerable<Pet> pets)
    {
        return pets
            .Select(ToResponse)
            .ToList();
    }

    // Update Request → Entity (aplica alterações)
    public static void UpdateEntity(Pet pet, UpdatePetRequest request)
{
    if (request.Peso != pet.Peso)
        pet.AlterarPeso(request.Peso);

    if (request.Status != pet.Status)
        pet.AlterarStatus(request.Status);
}
}