using STEMMA.Domain.Cadastro.Entities;
using STEMMA.Domain.Cadastro.Repositories;

namespace STEMMA.Application.Cadastro.UseCases.CreatePet;

public class CreatePetUseCase
{
    private readonly IPetRepository _repository;

    public CreatePetUseCase(IPetRepository repository)
    {
        _repository = repository;
    }

    public async Task<Guid> Execute(string nome, string raca, Guid tutorId)
    {
        var pet = new Pet(nome, raca, tutorId);

        await _repository.AddAsync(pet);

        return pet.Id;
    }
}