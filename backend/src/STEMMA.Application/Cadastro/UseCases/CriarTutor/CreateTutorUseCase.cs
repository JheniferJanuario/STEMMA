using STEMMA.Domain.Cadastro.Entities;
using STEMMA.Domain.Cadastro.Repositories;

namespace STEMMA.Application.Cadastro.UseCases.CreateTutor;

public class CreateTutorUseCase
{
    private readonly ITutorRepository _repository;

    public CreateTutorUseCase(ITutorRepository repository)
    {
        _repository = repository;
    }

    public async Task<Guid> Execute(string nome, string email)
    {
        var tutor = new Tutor(nome, email);

        await _repository.AddAsync(tutor);

        return tutor.Id;
    }
}