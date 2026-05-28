using STEMMA.Domain.Cadastro.Entities;
using STEMMA.Domain.Cadastro.Repositories;


namespace STEMMA.Application.Cadastro.UseCases.CriarTutor;

public class CreateTutorUseCase
{
    private readonly ITutorRepository _repository;

    public CreateTutorUseCase(ITutorRepository repository)
    {
        _repository = repository;
    }

    public async Task<Guid> Execute(
        string nome,
        string cpf,
        string email)
    {
        var tutor = new Tutor(
            nome,
            cpf,
            email);

        await _repository.AdicionarAsync(tutor);

        return tutor.Id;
    }
}