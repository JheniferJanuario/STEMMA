using STEMMA.Domain.Cadastro.Entities;
using STEMMA.Domain.Cadastro.Repositories;

namespace STEMMA.Application.Cadastro.UseCases.CriarPet;

public class CreatePetUseCase
{
    private readonly IPetRepository _repository;

    public CreatePetUseCase(IPetRepository repository)
    {
        _repository = repository;
    }

    public async Task<Guid> Execute(
        string nome,
        string raca,
        int idade,
        decimal peso,
        Guid tutorId)
    {
        var pet = new Pet(
            nome,
            raca,
            idade,
            peso,
            tutorId);

        await _repository.AdicionarAsync(pet);

        return pet.Id;
    }
}